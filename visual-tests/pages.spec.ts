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
  { name: "ecosystems", path: "/ecosystems/" },
  { name: "research", path: "/research/" },
  { name: "governance", path: "/governance/" },
  { name: "diversity", path: "/diversity/" },
  { name: "benchmarks", path: "/benchmarks/" },
  { name: "install", path: "/install/" },
  { name: "contribute", path: "/contribute/" },
  { name: "packages", path: "/packages/" },
  { name: "teaching", path: "/teaching/" },
];

async function prepareForScreenshot(page: Page) {
  // Wait for images/fonts to finish loading
  await page.waitForLoadState("networkidle");

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
  await page.waitForTimeout(200);
}

for (const { name, path } of PAGES) {
  test(`${name} visual snapshot`, async ({ page }) => {
    await page.goto(path, { waitUntil: "networkidle" });
    await prepareForScreenshot(page);

    await expect(page).toHaveScreenshot(`${name}.png`, {
      fullPage: true,
    });
  });
}
