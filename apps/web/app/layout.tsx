import { Geist_Mono } from "next/font/google";
import localFont from "next/font/local";

import "@workspace/ui/globals.css";
import { Providers } from "@/components/providers";

const fontSans = localFont({
  src: [
    {
      path: "../public/fonts/TWKLausanne-300.woff2",
      weight: "300",
      style: "normal",
    },
    {
      path: "../public/fonts/TWKLausanne-400.woff2",
      weight: "400",
      style: "normal",
    },
    {
      path: "../public/fonts/TWKLausanne-550.woff2",
      weight: "550",
      style: "normal",
    },
  ],
  variable: "--font-sans",
  display: "swap",
});

const fontMono = Geist_Mono({
  subsets: ["latin"],
  variable: "--font-mono",
});

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body
        className={`${fontSans.variable} ${fontMono.variable} font-sans antialiased `}
      >
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
