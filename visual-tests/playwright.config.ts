import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: ".",
  testMatch: "*.spec.ts",
  snapshotPathTemplate: "{testDir}/screenshots/{projectName}/{arg}{ext}",
  timeout: 60_000,
  retries: 0,
  workers: 1,

  expect: {
    toHaveScreenshot: {
      maxDiffPixelRatio: 0.01,
    },
  },

  use: {
    baseURL: "http://localhost:8234",
    colorScheme: "light",
    viewport: { width: 1280, height: 720 },
  },

  webServer: {
    command: "npx serve ../__site -l 8234",
    port: 8234,
    reuseExistingServer: !process.env.CI,
  },

  projects: [
    {
      name: "desktop",
      use: { viewport: { width: 1280, height: 720 } },
    },
    {
      name: "mobile",
      use: { viewport: { width: 375, height: 812 } },
    },
  ],
});
