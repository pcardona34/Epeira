/*
####################################################
### A G N o S t e p  -  Desktop
### (c) 2026 - Patrick Cardona
### Author: Patrick Cardona
###
### Thanks for the GNUstep Developers Community.
### This application is free software.
### Read complete License in the root directory.
####################################################

####################################################
### Epeira Helper
### A socket to embed Surf Web Browser
### C: epeira_socket.c
####################################################
*/

#include <gtk/gtk.h>
#include <gtk/gtkx.h>
#include <gdk/gdkx.h>
#include <X11/Xlib.h>

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

/*  Following Helper adapted from Agnostep Dico project - oct. 2026 */

static void
on_plug_added(GtkSocket *socket, gpointer data)
{
    (void)socket;
    GtkWidget *window = GTK_WIDGET(data);

    g_print("Epeira attached; minimizing helper window.\n");
    gtk_window_iconify(GTK_WINDOW(window));
}

static void
on_window_destroy(GtkWidget *widget, gpointer data)
{
    (void)widget;
    (void)data;
    gtk_main_quit();
}

static unsigned long
parse_number(const char *text, const char *name)
{
    char *end = NULL;
    errno = 0;
    unsigned long value = strtoul(text, &end, 0);

    if (errno != 0 || end == text || *end != '\0') {
        fprintf(stderr, "Invalid %s: %s\n", name, text);
        exit(EXIT_FAILURE);
    }
    return value;
}

int
main(int argc, char **argv)
{
    if (argc != 7) {
        fprintf(stderr, "Usage: %s PARENT_XID X Y WIDTH HEIGHT URL\n", argv[0]);
        return EXIT_FAILURE;
    }

    Window parent_xid = (Window)parse_number(argv[1], "parent XID");
    int x = (int)parse_number(argv[2], "x");
    int y = (int)parse_number(argv[3], "y");
    unsigned int width = (unsigned int)parse_number(argv[4], "width");
    unsigned int height = (unsigned int)parse_number(argv[5], "height");
    const char *url = argv[6];

    gtk_init(&argc, &argv);

    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    GtkWidget *socket = gtk_socket_new();

    gtk_window_set_default_size(GTK_WINDOW(window), width, height);
    gtk_container_add(GTK_CONTAINER(window), socket);

    g_signal_connect(socket, "plug-added",
                 G_CALLBACK(on_plug_added), window);

    g_signal_connect(window, "destroy",
                     G_CALLBACK(on_window_destroy), NULL);

    gtk_widget_show_all(window);
    gtk_widget_realize(socket);

    Display *display = GDK_DISPLAY_XDISPLAY(gdk_display_get_default());
    Window socket_xid = gtk_socket_get_id(GTK_SOCKET(socket));

    XReparentWindow(display, socket_xid, parent_xid, x, y);
    XMoveResizeWindow(display, socket_xid, x, y, width, height);
    XMapWindow(display, socket_xid);
        
    XSync(display, False);

    char *socket_id = g_strdup_printf("0x%lx",
                                  (unsigned long)socket_xid);

    char *surf_argv[] = {
    "/usr/bin/surf",
    "-e", socket_id,
    "-z", "1.5",
    (char *)url,
    NULL
    };

    GError *error = NULL;
    if (!g_spawn_async(NULL, surf_argv, NULL,
                   G_SPAWN_SEARCH_PATH,
                   NULL, NULL, NULL, &error)) {
      g_printerr("Could not start Surf: %s\n", error->message);
      g_error_free(error);
      g_free(socket_id);
      return EXIT_FAILURE;
    }

    g_free(socket_id);
    gtk_main();

    return EXIT_SUCCESS;
}

