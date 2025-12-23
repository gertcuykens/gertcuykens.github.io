#!/bin/zsh
systemctl stop odoo.service
cd /home/odoo/19
/home/odoo/.local/bin/uv run ./odoo-bin -c /home/odoo/odoo.conf -d $1 -u all --no-http --workers=0 --stop-after-init
# /home/odoo/.local/bin/uv run ./odoo-bin -c /home/odoo/odoo.conf -d $1 -i edi_tools --no-http --workers=0 --stop-after-init
# /home/odoo/.local/bin/uv run ./odoo-bin shell -c /home/odoo/odoo.conf -d $1 --no-http --workers=0

# self.env['ir.module.module'].search([('name', '=', 'data_merge')]).button_immediate_uninstall()
# update ir_module_module set state='to remove' where name='data_merge';

