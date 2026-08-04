import type { Metadata } from "next";
import Link from "next/link";
import { SiteHeader } from "@/components/layout/site-header";
import { SiteFooter } from "@/components/layout/site-footer";

export const metadata: Metadata = {
  title: "Privacy",
  description: "Privacy policy for Compass waitlist and website.",
};

export default function PrivacyPage() {
  return (
    <>
      <SiteHeader />
      <main id="main" className="mx-auto max-w-3xl px-6 pb-24 pt-32">
        <h1 className="font-display text-4xl font-semibold tracking-tight">Privacy</h1>
        <p className="mt-6 text-muted-foreground">
          Compass collects waitlist email addresses solely to notify you about product
          updates and early access. We do not sell personal data. You can request removal
          at any time by contacting the maintainers via{" "}
          <Link
            href="https://github.com/ashlessscythe/compass"
            className="text-primary underline-offset-4 hover:underline"
          >
            GitHub
          </Link>
          .
        </p>
        <p className="mt-4 text-muted-foreground">
          This site may use standard hosting analytics. No advertising trackers are
          embedded by default.
        </p>
      </main>
      <SiteFooter />
    </>
  );
}
