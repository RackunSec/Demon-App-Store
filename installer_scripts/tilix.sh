#!/usr/bin/env bash
# 2020 Demon App Store
# WeakNet Labs
#
# Installer script, should be called from the workflow app
# INSTALL:
# --------------------
# Tilix, Tilix-Common
# --------------------
# NOTES:
#   Tilix Terminal Emulator is pretty slick.
#
# DO NOT INFO:
printf "\n[INFO] Installer script initiated: $(echo $0)\n"
#
apt install -y tilix tilix-common # simple
