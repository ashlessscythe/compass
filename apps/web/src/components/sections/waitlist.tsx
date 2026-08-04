"use client";

import { FormEvent, useState } from "react";
import { motion } from "framer-motion";
import { Check, Loader2 } from "lucide-react";
import { CompassApiClient } from "@compass/api";
import { siteCopy } from "@compass/branding";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { FadeIn } from "@/components/motion/fade-in";

const client = new CompassApiClient();

export function Waitlist() {
  const [email, setEmail] = useState("");
  const [status, setStatus] = useState<"idle" | "loading" | "success" | "error">(
    "idle",
  );
  const [message, setMessage] = useState("");

  async function onSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!email.trim()) return;

    setStatus("loading");
    setMessage("");

    try {
      const result = await client.joinWaitlist({
        email: email.trim(),
        source: "landing",
      });

      if (result.ok) {
        setStatus("success");
        setMessage(result.message || siteCopy.waitlist.success);
        setEmail("");
      } else {
        setStatus("error");
        setMessage(result.message || "Something went wrong. Please try again.");
      }
    } catch {
      setStatus("error");
      setMessage("Unable to reach the server. Please try again.");
    }
  }

  return (
    <section
      id="waitlist"
      className="relative px-6 py-24 md:py-32"
      aria-labelledby="waitlist-heading"
    >
      <div className="mx-auto max-w-3xl">
        <FadeIn blur>
          <div className="glass relative overflow-hidden rounded-3xl px-6 py-12 text-center sm:px-12 md:py-16">
            <div
              aria-hidden
              className="pointer-events-none absolute inset-0 bg-[radial-gradient(ellipse_at_top,rgba(91,141,239,0.18),transparent_55%)]"
            />
            <div className="relative">
              <h2
                id="waitlist-heading"
                className="font-display text-3xl font-semibold tracking-tight sm:text-4xl"
              >
                {siteCopy.waitlist.title}
              </h2>
              <p className="mx-auto mt-4 max-w-xl text-muted-foreground">
                {siteCopy.waitlist.description}
              </p>

              {status === "success" ? (
                <motion.div
                  initial={{ opacity: 0, scale: 0.96 }}
                  animate={{ opacity: 1, scale: 1 }}
                  className="mx-auto mt-8 flex max-w-md items-center justify-center gap-2 rounded-xl border border-emerald-500/30 bg-emerald-500/10 px-4 py-3 text-emerald-300"
                  role="status"
                >
                  <Check className="size-4 shrink-0" aria-hidden />
                  <p className="text-sm">{message}</p>
                </motion.div>
              ) : (
                <form
                  onSubmit={onSubmit}
                  className="mx-auto mt-8 flex w-full max-w-md flex-col gap-3 sm:flex-row"
                  noValidate
                >
                  <label htmlFor="waitlist-email" className="sr-only">
                    Email address
                  </label>
                  <Input
                    id="waitlist-email"
                    type="email"
                    name="email"
                    autoComplete="email"
                    required
                    placeholder={siteCopy.waitlist.placeholder}
                    value={email}
                    onChange={(event) => setEmail(event.target.value)}
                    disabled={status === "loading"}
                    aria-invalid={status === "error"}
                    aria-describedby={status === "error" ? "waitlist-error" : undefined}
                    className="h-12 bg-black/30"
                  />
                  <Button
                    type="submit"
                    size="lg"
                    disabled={status === "loading"}
                    className="h-12 shrink-0"
                  >
                    {status === "loading" ? (
                      <>
                        <Loader2 className="size-4 animate-spin" aria-hidden />
                        Joining…
                      </>
                    ) : (
                      siteCopy.waitlist.submit
                    )}
                  </Button>
                </form>
              )}

              {status === "error" && message ? (
                <p
                  id="waitlist-error"
                  className="mt-3 text-sm text-destructive"
                  role="alert"
                >
                  {message}
                </p>
              ) : null}
            </div>
          </div>
        </FadeIn>
      </div>
    </section>
  );
}
