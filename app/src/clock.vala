[GtkTemplate(ui = "/com/github/sleeeee/sietch/ui/clock.ui")]
public class Clock : Gtk.Box {
  private uint timeout;

  [GtkChild]
  private unowned Gtk.Label hours;
  [GtkChild]
  private unowned Gtk.Label minutes;
  [GtkChild]
  private unowned Gtk.Popover clock_popover;

  [GtkCallback]
  public void toggle_popover() {
    this.clock_popover.popup();
  }

  private void sync_clock() {
    GLib.DateTime now = new GLib.DateTime.now_local();
    this.hours.label = now.format("%H");
    this.minutes.label = now.format("%M");
  }

  construct {
    this.timeout = GLib.Timeout.add(10000, () => {
      this.sync_clock();
      return GLib.Source.CONTINUE;
    });
    this.sync_clock();
  }

  public override void dispose() {
    GLib.Source.remove(this.timeout);
    base.dispose();
  }

  class construct {
    set_css_name("clock");
  }
}
