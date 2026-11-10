import { View, div, svg } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { exec, theme } from "herdr";

const LIMIT = 1900;
const REFRESH_MS = 5 * 60 * 1000;
const DAY_MS = 24 * 60 * 60 * 1000;


function periodFor(resetAt) {
  const end = new Date(resetAt);
  if (Number.isNaN(end.getTime())) return null;
  const start = new Date(Date.UTC(end.getUTCFullYear(), end.getUTCMonth() - 1, end.getUTCDate()));
  return { start, end, days: Math.round((end - start) / DAY_MS) };
}



function oneDecimal(value) {
  return value.toFixed(1);
}

export default class CopilotQuota extends View {
  init(_props, cx) {
    this.data = null;
    this.error = null;
    this.refresh(cx);
    cx.timer.every(REFRESH_MS, (cx) => this.refresh(cx));
  }

  refresh(cx) {
    cx.spawn(async (cx) => {
      try {
        const result = await exec("gh", ["api", "copilot_internal/user"]);
        if (result.code !== 0) throw new Error(result.stderr?.trim() || "gh api failed");
        const response = JSON.parse(result.stdout);
        const premium = response.quota_snapshots?.premium_interactions;
        const resetAt = response.quota_reset_date_utc || response.quota_reset_date;
        const period = periodFor(resetAt);
        if (!premium || !period) throw new Error("Copilot quota response is incomplete");
        this.data = { used: Number(premium.credits_used), resetAt: period.end, period };
        this.error = null;
      } catch (error) {
        this.error = String(error.message || error);
      }
      cx.notify();
    });
  }

  render() {
    const t = theme();
    const root = v_flex()
      .id("copilot-quota")
      .size_full()
      .p(6)
      .px(10)
      .gap(4)
      .bg(t.chrome)
      .text_size(12);
    const badge = (text, color) =>
      div().px(2).rounded(5).font_semibold().text_color(color).child(String(text));
    const arrow = () => div().px(8).text_color(t.dim).child("→");
    const at = () => div().px(8).text_color(t.dim).child("@");

    if (this.error) return root.child(div().text_color(t.dim).child("Copilot unavailable"));
    if (!this.data) return root.child(div().text_color(t.dim).child("Copilot …"));

    const { used, period } = this.data;
    const elapsedDays = Math.min(period.days, Math.max(1, Math.ceil((Date.now() - period.start.getTime()) / DAY_MS)));
    const targetPerDay = LIMIT / period.days;
    const expected = targetPerDay * elapsedDays;
    const difference = used - expected;
    const daysAhead = difference / targetPerDay;
    const estimate = (used / elapsedDays) * period.days;
    const overage = estimate - LIMIT;
    const paceColor = difference > 0 ? t.blocked : t.done;
    const estimateColor = overage > 0 ? t.blocked : t.done;
    const signed = (value) => `${value >= 0 ? "+" : "-"}${Math.abs(value)}`;

    const usage = h_flex()
      .items_center()
      .gap(8)
      .child(svg("icons/copilot.svg").size(15).flex_none().text_color(t.accent))
      .child(
        h_flex()
          .items_center()
          .child(badge(Math.round(used), t.foreground))
          .child(badge(`[${signed(Math.round(difference))}]`, t.muted))
          .child(arrow())
          .child(badge(Math.round(estimate), t.foreground))
          .child(badge(`[${signed(Math.round(overage))}]`, t.muted))
          .child(at())
          .child(badge(`${Math.round(targetPerDay)}/d`, t.muted)),
      );

    return root.child(usage)
  }
}
