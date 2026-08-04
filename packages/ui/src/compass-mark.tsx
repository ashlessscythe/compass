import type { SVGProps } from "react";
import { cn } from "./cn";

export interface CompassMarkProps extends SVGProps<SVGSVGElement> {
  title?: string;
}

/**
 * Geometric compass mark — minimal, modern, software-startup aesthetic.
 */
export function CompassMark({
  className,
  title = "Compass",
  ...props
}: CompassMarkProps) {
  return (
    <svg
      viewBox="0 0 32 32"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      role="img"
      aria-label={title}
      className={cn("shrink-0", className)}
      {...props}
    >
      <title>{title}</title>
      <circle
        cx="16"
        cy="16"
        r="14"
        stroke="currentColor"
        strokeWidth="1.5"
        opacity="0.9"
      />
      <circle cx="16" cy="16" r="2.25" fill="currentColor" />
      <path
        d="M16 5.5L18.2 13.8L16 16L13.8 13.8L16 5.5Z"
        fill="currentColor"
      />
      <path
        d="M16 26.5L13.8 18.2L16 16L18.2 18.2L16 26.5Z"
        fill="currentColor"
        opacity="0.35"
      />
      <path
        d="M5.5 16L13.8 13.8L16 16L13.8 18.2L5.5 16Z"
        fill="currentColor"
        opacity="0.55"
      />
      <path
        d="M26.5 16L18.2 18.2L16 16L18.2 13.8L26.5 16Z"
        fill="currentColor"
        opacity="0.55"
      />
    </svg>
  );
}
