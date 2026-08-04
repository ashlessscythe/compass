import { SiteHeader } from "@/components/layout/site-header";
import { SiteFooter } from "@/components/layout/site-footer";
import { Hero } from "@/components/sections/hero";
import { Features } from "@/components/sections/features";
import { Vision } from "@/components/sections/vision";
import { Waitlist } from "@/components/sections/waitlist";

export default function HomePage() {
  return (
    <>
      <SiteHeader />
      <main id="main">
        <Hero />
        <Features />
        <Vision />
        <Waitlist />
      </main>
      <SiteFooter />
    </>
  );
}
