[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/battery.ui")]
public class Battery : Gtk.Box {
  public AstalBattery.Device battery { get; private set; }

  [GtkChild]
  private unowned CircularProgress battery_progress;
  [GtkChild]
  private unowned Gtk.Image battery_icon;
  [GtkChild]
  private unowned Gtk.Popover battery_popover;

  [GtkCallback]
  public void toggle_popover() {
    this.battery_popover.popup();
  }

  [GtkCallback]
  public string get_status_label(bool is_charging) {
    return this.battery.charging ? "Charging" : "Discharging";
  }

  [GtkCallback]
  public string get_percentage_label(double percentage) {
    return "%d%%".printf((int)(percentage * 100));
  }

  [GtkCallback]
  public string get_time_remaining_label(uint64 update_time) {
    int64 seconds = this.battery.charging ? this.battery.time_to_full : this.battery.time_to_empty;
    return "%02d:%02d".printf((int)seconds/3600, (int)(seconds%3600)/60);
  }

  [GtkCallback]
  public string get_power_rate_label(double power_rate) {
    return "%.2f W".printf(power_rate);
  }

  [GtkCallback]
  public string get_energy_label(double energy) {
    return "%.2f Wh".printf(energy);
  }

  private void set_percentage_class(double percentage, bool is_charging) {
    if ((!is_charging && percentage <= 0.3) || (is_charging && percentage >= 0.9)) {
      if (!this.battery_progress.has_css_class("warning")) { this.battery_progress.add_css_class("warning"); }
      if (!this.battery_icon.has_css_class("warning")) { this.battery_icon.add_css_class("warning"); }
    } else {
      if (this.battery_progress.has_css_class("warning")) { this.battery_progress.remove_css_class("warning"); }
      if (this.battery_icon.has_css_class("warning")) { this.battery_icon.remove_css_class("warning"); }
    }
  }


  construct {
    this.battery = AstalBattery.get_default();
    if (this.battery.is_present) {
      this.battery.notify["percentage"].connect(() => { set_percentage_class(this.battery.percentage, this.battery.charging); });
      this.battery.notify["charging"].connect(() => { set_percentage_class(this.battery.percentage, this.battery.charging); });
      set_percentage_class(this.battery.percentage, this.battery.charging);
    } else {
      this.dispose();
    }
  }
}
