import { test, expect, Page } from "@playwright/test";
import * as fs from "fs";
import * as path from "path";

/**
 * Pages that make up the core user-facing surface of julialang.org.
 * Each entry becomes a separate test so failures are isolated per page.
 */
const PAGES: { name: string; path: string }[] = [
  { name: "homepage", path: "/" },
  { name: "downloads", path: "/downloads/" },
  { name: "learning", path: "/learning/" },
  { name: "blog", path: "/blog/" },
  { name: "community", path: "/community/" },
  { name: "research", path: "/research/" },
  { name: "governance", path: "/governance/" },
  { name: "diversity", path: "/diversity/" },
  { name: "benchmarks", path: "/benchmarks/" },
  { name: "contribute", path: "/contribute/" },
];

async function prepareForScreenshot(page: Page) {
  // Freeze animated GIFs by drawing their current frame onto a canvas
  await page.evaluate(() => {
    document.querySelectorAll('img[src$=".gif"]').forEach((img) => {
      const el = img as HTMLImageElement;
      if (!el.complete || el.naturalWidth === 0) return;
      const canvas = document.createElement("canvas");
      canvas.width = el.naturalWidth;
      canvas.height = el.naturalHeight;
      canvas.getContext("2d")!.drawImage(el, 0, 0);
      canvas.style.cssText = el.style.cssText;
      canvas.className = el.className;
      el.replaceWith(canvas);
    });

    // Replace external iframes (YouTube, GitHub buttons, etc.) with
    // static placeholders so async-loading content doesn't flicker.
    document.querySelectorAll("iframe").forEach((iframe) => {
      const placeholder = document.createElement("div");
      placeholder.style.cssText = `
        width: ${iframe.offsetWidth}px;
        height: ${iframe.offsetHeight}px;
        background: #e0e0e0;
      `;
      iframe.replaceWith(placeholder);
    });
  });

  // Disable CSS animations/transitions to avoid flaky diffs
  await page.addStyleTag({
    content: `
      *, *::before, *::after {
        animation-duration: 0s !important;
        animation-delay: 0s !important;
        transition-duration: 0s !important;
        transition-delay: 0s !important;
        caret-color: transparent !important;
      }
    `,
  });

  // Give the browser a frame to apply the above overrides
  await page.waitForTimeout(500);
}

for (const { name, path: pagePath } of PAGES) {
  test(`${name} visual snapshot`, async ({ page }, testInfo) => {
    await page.goto(pagePath, { waitUntil: "load" });
    await prepareForScreenshot(page);

    const isUpdate = testInfo.config.updateSnapshots === "all";

    try {
      await expect(page).toHaveScreenshot(`${name}.png`, {
        fullPage: true,
        timeout: 3_000,
      });
    } catch (err) {
      if (!isUpdate) throw err;
      // Baseline capture: page never stabilized — save a single screenshot
      // so comparisons still run rather than erroring with no baseline.
      const snapshotDir = path.join(
        testInfo.project.testDir,
        "screenshots",
        testInfo.project.name,
      );
      fs.mkdirSync(snapshotDir, { recursive: true });
      const snapshotPath = path.join(snapshotDir, `${name}.png`);
      const buffer = await page.screenshot({ fullPage: true });
      fs.writeFileSync(snapshotPath, buffer);
    }
  });
}
