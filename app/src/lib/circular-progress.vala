using GLib.Math;

public class CircularProgress : Gtk.Widget {
  private double _percentage;
  public double percentage {
    get { return this._percentage; }
    set {
      if (value != this._percentage) {
        this._percentage = value > 1.0 ? 1.0 : (value < 0.0 ? 0.0 : value);
      }
    }
  }

  construct {
    this.set_size_request(40, 40);
    this.set_css_classes({"circular-progress"});
    this.notify.connect(() => { this.queue_draw(); });
  }

  protected override void snapshot(Gtk.Snapshot snapshot) {
    int width = this.get_width();
    int height = this.get_height();
    double center_x = width / 2;
    double center_y = width / 2;
    double radius = double.min(width / 2.0f, height / 2.0f) - 1; // 1 = line_width / 2

    Gdk.RGBA color = this.get_color();

    if (this.percentage > 0) {
      Gsk.PathBuilder path = new Gsk.PathBuilder();
      double start_angle = -Math.PI / 2.0;
      double end_angle = start_angle + (2 * Math.PI * this.percentage);
      double start_x = center_x + radius * Math.cos(start_angle);
      double start_y = center_y + radius * Math.sin(start_angle);
      path.move_to((float)start_x, (float)start_y);

      if (this.percentage <= 0.5) {
        // Can draw in a single arc if less than 180 degrees
        double end_x = center_x + radius * Math.cos(end_angle);
        double end_y = center_x + radius * Math.sin(end_angle);
        path.svg_arc_to((float)radius, (float)radius, 0.0f, false, true, (float)end_x, (float)end_y);
      } else {
        // Two separate arcs if more than 180 degrees
        double mid_angle = start_angle + Math.PI;
        double mid_x = center_x + radius * Math.cos(mid_angle);
        double mid_y = center_y + radius * Math.sin(mid_angle);
        path.svg_arc_to((float)radius, (float)radius, 0.0f, false, true, (float)mid_x, (float)mid_y);

        double end_x = center_x + radius * Math.cos(end_angle);
        double end_y = center_y + radius * Math.sin(end_angle);
        path.svg_arc_to((float)radius, (float)radius, 0.0f, false, true, (float)end_x, (float)end_y);
      }
      Gsk.Stroke stroke = new Gsk.Stroke(2);
      snapshot.append_stroke(path.to_path(), stroke, color);
    }
  }
}
