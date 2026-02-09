#!/bin/zsh
systemctl stop 19.service
cd /home/odoo/19
# uv run ./odoo-bin -c /home/odoo/19.conf -d $1 -u all --no-http --workers=0 --stop-after-init
# uv run ./odoo-bin -c /home/odoo/19.conf -d $1 -i base,web,web_enterprise --no-http --workers=0 --stop-after-init

uv run ./odoo-bin shell -c /home/odoo/19.conf -d $1 --no-http --workers=0
# self.env['ir.module.module'].search([('name', '=', 'data_merge')]).button_immediate_uninstall()
# self.env['ir.attachment'].search([('url', '=like', '/web/assets/%')]).unlink()
# self.env.cr.commit()
# exit()

