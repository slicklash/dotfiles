#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# ruff: noqa: E501

import sys

import gi
from gi.repository import Gimp, GLib

gi.require_version("Gimp", "3.0")
gi.require_version("GimpUi", "3.0")


class Plugin (Gimp.PlugIn):
    NAME = "plug-in-py3-remove-bg"
    BINARY = "py3-remove-bg"
    MENU_PATH = "<Image>/⭐ _Plugins"
    MENU_LABEL = "_Remove Background"

    def do_query_procedures(self):
        return [self.NAME]

    def do_create_procedure(self, name):
        if name != self.NAME:
            return None

        proc = Gimp.ImageProcedure.new(self, name, Gimp.PDBProcType.PLUGIN, self.run_proc, None)
        proc.set_sensitivity_mask(Gimp.ProcedureSensitivityMask.DRAWABLE | Gimp.ProcedureSensitivityMask.NO_DRAWABLES)
        proc.set_menu_label(self.MENU_LABEL)
        proc.add_menu_path(self.MENU_PATH)

        return proc

    def run_proc(self, procedure, run_mode, image, drawables, config, data):
        if len(drawables) > 1:
            return self._error(procedure, "single layer required")

        if not isinstance(drawables[0], Gimp.Layer):
            return self._error(procedure, "only layers are supported")

        # image = Gimp.get_images()[0]

        s = image.get_selection()
        if (s.is_empty(image)):
            return self._error(procedure, "empty selection")

        image.undo_group_start()

        s.invert(image)
        s.shrink(image, 1)
        s.feather(image, 2)

        layer = Gimp.Image.get_layers(image)[0]
        Gimp.edit_copy([layer])

        new_layer = Gimp.Layer.new(image, "new", image.get_width(), image.get_height(), Gimp.ImageType.RGBA_IMAGE, 100, Gimp.LayerMode.NORMAL)
        image.insert_layer(new_layer, layer.get_parent(), 0)

        flo = Gimp.edit_paste(new_layer, True)[0]
        Gimp.floating_sel_anchor(flo)

        image.remove_layer(layer)

        image.undo_group_end()

        return procedure.new_return_values(Gimp.PDBStatusType.SUCCESS, None)

    def _error(self, procedure, message):
        message = f"ERROR: {message}"
        return procedure.new_return_values(Gimp.PDBStatusType.CALLING_ERROR, GLib.Error(message))


Gimp.main(Plugin.__gtype__, sys.argv)
