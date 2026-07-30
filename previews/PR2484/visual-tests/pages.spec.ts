import { test, expect, Page } from "@playwright/test";

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

for (const { name, path } of PAGES) {
  test(`${name} visual snapshot`, async ({ page }) => {
    await page.goto(path, { waitUntil: "load" });
    await prepareForScreenshot(page);

    await expect(page).toHaveScreenshot(`${name}.png`, {
      fullPage: true,
      timeout: 15_000,
    });
  });
}
