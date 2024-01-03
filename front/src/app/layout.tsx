import "./globals.css";

import type { Metadata } from "next";
import { Inter } from "next/font/google";
import Footer from "@/components/common/Footer";
import Navbar from "@/components/common/Navbar";
import RecoilProvider from "@/providers/recoilProvider";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Resume",
  description: "LEL project",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <RecoilProvider>
      <html lang="en" className="dark" data-theme="dark">
        <body className={inter.className}>
          <div className="flex flex-col mx-auto h-screen">
            <Navbar />
            <div className="flex-grow pb-2">{children}</div>
            <Footer />
          </div>
        </body>
      </html>
    </RecoilProvider>
  );
}
