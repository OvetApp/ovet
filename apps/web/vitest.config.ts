import { defineConfig } from "vitest/config";
import { resolve } from "path";

export default defineConfig({
  test: {
    environment: "jsdom",
    setupFiles: ["./src/test/setup.ts"],
    globals: true,
    exclude: [
      "node_modules/**",
      "dist/**",
      ".next/**",
      "tests/e2e/**",
      "playwright-report/**",
      "coverage/**",
    ],
  },
  resolve: {
    alias: {
      "@": resolve(__dirname, "./"),
    },
  },
});
