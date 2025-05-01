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

  private void set_percentage_class(double percentage) {
    if (percentage > 0.3 && percentage < 0.9) {
      if (this.battery_progress.has_css_class("warning")) { this.battery_progress.remove_css_class("warning"); }
      if (this.battery_icon.has_css_class("warning")) { this.battery_icon.remove_css_class("warning"); }
    } else {
      if (!this.battery_progress.has_css_class("warning")) { this.battery_progress.add_css_class("warning"); }
      if (!this.battery_icon.has_css_class("warning")) { this.battery_icon.add_css_class("warning"); }
    }
  }

  construct {
    this.battery = AstalBattery.get_default();
    if (this.battery.is_present) {
      this.battery.notify["percentage"].connect(() => { set_percentage_class(this.battery.percentage); });
      set_percentage_class(this.battery.percentage);
    } else {
      this.dispose();
    }
  }
}
