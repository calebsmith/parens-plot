#include <gtk/gtk.h>
#include <libguile.h>


#define WINDOW_WIDTH  800
#define WINDOW_HEIGHT 800

/*
 * A quick dropin thing to get cairo working
 */
static gboolean draw_cb(GtkWidget *widget, cairo_t *cr, gpointer data)
{
    /* Set color for background */
    cairo_set_source_rgb(cr, 1, 1, 1);
    /* fill in the background color*/
    cairo_paint(cr);

    /* set color for rectangle */
    cairo_set_source_rgb(cr, 0.42, 0.65, 0.80);
    /* set the line width */
    cairo_set_line_width(cr,6);
    /* draw the rectangle's path beginning at 3,3 */
    cairo_rectangle (cr, 3, 3, 100, 100);
    /* stroke the rectangle's path with the chosen color so it's actually visible */
    cairo_stroke(cr);

    return FALSE;
}

/* Takes a GtkTextView* and returns a gchar* of the full string in its
 * GtkTextBuffer. (A convenience function to avoid ceremony of getting outter
 * bounds
 */
static gchar* gtkcontrib_text_view_get_text(GtkTextView* text_view)
{
    GtkTextBuffer* buffer;
    GtkTextIter txti_start;
    GtkTextIter txti_end;

    buffer = gtk_text_view_get_buffer(text_view);
    gtk_text_buffer_get_bounds(buffer, &txti_start, &txti_end);
    return gtk_text_buffer_get_text(buffer, &txti_start, &txti_end, TRUE);
}

/*
 * Grabs text entry data when Run is clicked. DUMMY procedure for now
 */
static void run_cb(GtkWidget *widget, gpointer data )
{
    gchar* text;
    SCM result;

    text = gtkcontrib_text_view_get_text((GtkTextView*) data);
    // TODO: Make result display somehow

    scm_c_define("a", scm_from_int(3));
    result = scm_c_eval_string(text);
}

/*
 * Bootstrap the GTK window and its widgets
 */
static void create_gtk_gui()
{
    GtkWidget* window;
    GtkWidget* da;
    GtkWidget* txt_box;
    GtkWidget* grid;
    GtkWidget* button;
    GtkTextBuffer* buffer;

    // Build window
    window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "(plot)");
    g_signal_connect (window, "destroy", G_CALLBACK (gtk_main_quit), NULL);
    // Build Drawing area
    da = gtk_drawing_area_new();
    gtk_widget_set_size_request (da, WINDOW_WIDTH, WINDOW_HEIGHT);
    g_signal_connect (da, "draw", G_CALLBACK(draw_cb),  NULL);
    gtk_widget_show(da);
    // Build Text box
    buffer = gtk_text_buffer_new(NULL);
    txt_box = gtk_text_view_new_with_buffer(buffer);
    gtk_widget_show(txt_box);
    // Build button
    button = gtk_button_new_with_label("Run");
    g_signal_connect (button, "clicked", G_CALLBACK (run_cb), (gpointer) txt_box);
    // Build grid
    grid = gtk_grid_new();
    gtk_grid_attach(GTK_GRID(grid), da, 0, 0, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), txt_box, 0, 1, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), button, 1, 1, 1, 1);
    gtk_container_add(GTK_CONTAINER(window), grid);
    gtk_widget_show_all(window);
}
static void inner_main(void *nop, int argc, char *argv[])
{
    gtk_init(&argc, &argv);
    create_gtk_gui();
    gtk_main();
    return;
}

int main(int argc, char* argv[])
{
    scm_boot_guile(argc, argv, &inner_main, NULL);
    // FIXME: Doesn't seem to load local scm file
    scm_c_primitive_load("test.scm");
    return 0;
}


/*
 *
 * Adding this boilerplate in case its helpful. Can't seem to get exception
 * handling going.

SCM my_body_proc (void *body_data)
{
  // Execute the code in which you want to catch errors here.
}

SCM my_handler_proc (void *handler_data,
                     SCM key,
                     SCM parameters)
{
  // Put the code which you want to handle an error here.
}

{
  scm_c_catch (SCM_BOOL_T,
               my_body_proc, body_data,
               my_handler_proc, handler_data,
               NULL, NULL);
}
*/
