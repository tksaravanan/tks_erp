#!/bin/bash
git add .
git commit -m "$1"
git branch -M main
git remote add origin https://github.com/tksaravanan/tks_erp.git
git push -u origin main