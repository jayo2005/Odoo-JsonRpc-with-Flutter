# -*- coding: utf-8 -*-
# Copyright 2022-Today TechKhedut.
# Part of TechKhedut. See LICENSE file for full copyright and licensing details.
from odoo import models, fields, api, _
from odoo.exceptions import ValidationError





class VehicleProduct(models.Model):
    """Vehicle Product"""
    _inherit = 'product.product'
    _description = __doc__

    is_vehicle_part = fields.Boolean(string="Vehicle Part")
    is_vehicle_service = fields.Boolean(string="Vehicle Service")


class SaleOrder(models.Model):
    """Sale Order"""
    _inherit = 'sale.order'
    _description = __doc__

    job_card_id = fields.Many2one('job.card', string="Job Card")

    def _prepare_invoice(self):
        res = super(SaleOrder, self)._prepare_invoice()
        if self.job_card_id:
            res['job_card_id'] = self.job_card_id.id
        return res


class VehicleRepairInvoice(models.Model):
    """Vehicle Repair Invoice"""
    _inherit = 'account.move'
    _description = __doc__

    job_card_id = fields.Many2one('job.card', string="Job Card")


class HrEmployee(models.Model):
    """Employee"""
    _inherit = 'hr.employee'
    _description = __doc__

    is_technician = fields.Boolean(string="Technician")
    is_supervisor = fields.Boolean(string="Supervisor")


class VehicleSparePart(models.Model):
    """Vehicle Spare part"""
    _name = 'vehicle.spare.part'
    _description = __doc__
    _rec_name = 'product_id'

    image_1920 = fields.Binary(related="product_id.image_1920")
    product_id = fields.Many2one('product.product', string='Product', required=True,
                                 domain="[('is_vehicle_part','=',True)]")
    qty = fields.Integer(string="Quantity", required=True, default=1)
    unit_price = fields.Monetary(string="Unit Price")

    company_id = fields.Many2one('res.company', default=lambda self: self.env.company)
    currency_id = fields.Many2one('res.currency', string='Currency', related="company_id.currency_id")
    job_card_id = fields.Many2one('job.card')

    @api.onchange('product_id')
    def vehicle_product_price(self):
        for rec in self:
            if rec.product_id:
                rec.unit_price = rec.product_id.lst_price

    @api.constrains('qty')
    def _check_quantity(self):
        for record in self:
            if record.qty == 0:
                raise ValidationError("Please Spare Parts Quantity can not be zero")


class VehicleServiceLine(models.Model):
    """Vehicle Service Line"""
    _name = 'vehicle.service.line'
    _description = __doc__
    _rec_name = 'vehicle_service_id'

    vehicle_service_id = fields.Many2one('product.product', string="Service",
                                         domain=[('is_vehicle_service', '=', True)], required=True)
    internal_notes = fields.Html(string="Internal Notes")
    service_hours = fields.Char(string="Service Time")
    service_charge = fields.Monetary(string="Service Charge")
    company_id = fields.Many2one('res.company', default=lambda self: self.env.company)
    currency_id = fields.Many2one('res.currency', string='Currency', related="company_id.currency_id")
    job_card_id = fields.Many2one('job.card')

    @api.onchange('vehicle_service_id')
    def get_vehicle_service_details(self):
        for rec in self:
            if rec.vehicle_service_id:
                rec.internal_notes = rec.vehicle_service_id.description
                rec.service_charge = rec.vehicle_service_id.lst_price


class JobCard(models.Model):
    """Vehicle Job Card"""
    _name = 'job.card'
    _description = __doc__
    _inherit = ['mail.thread', 'mail.activity.mixin']
    _rec_name = 'job_card_number'

    avatar = fields.Binary(string="Image")
    job_card_number = fields.Char(string='Job Card No', required=True, readonly=True, default=lambda self: ('New'))
    date = fields.Datetime(string="Job card date/time", required=True, default=fields.Datetime.now)
    customer_id = fields.Many2one('res.partner', string='Customer', required=True)
    vehicle_brand_id = fields.Many2one('vehicle.brand', string="Name", required=False)
    vehicle_model_id = fields.Many2one('vehicle.model', string="False",
                                       domain="[('vehicle_brand_id', '=', vehicle_brand_id)]", required=False)
    reg_no = fields.Char(string="Reg Number")
    chassis_no = fields.Char(string="Chassis Number")
    vin_no = fields.Char(string="VIN Number")
    engine_no = fields.Char(string="Engine Number")
    battery_volt = fields.Char(string="Battery Voltage")
    kms_reading = fields.Integer(string="KMS Reading")
    receiving_date = fields.Date(string="Receiving Date", required=False)
    delivery_date = fields.Date(string="Delivery Date", required=False)
    dtc_code = fields.Char(string="DTC Errors")

    type_of_service = fields.Selection(
        [('full', "Full service"), ('interim', "Interim service"), ('major', "Major Service")],
        string="Type of Service")
    service_type = fields.Selection([('free', "Free"), ('paid', "Paid")], string="Service Type", default='free')
    company_id = fields.Many2one('res.company', default=lambda self: self.env.company)
    currency_id = fields.Many2one('res.currency', string='Currency', related="company_id.currency_id")
    technician_id = fields.Many2one('hr.employee', string="Technician")
    supervisor_id = fields.Many2one('hr.employee', string="Supervisor", domain=[('is_supervisor', '=', True)],
                                    required=False)
    assign_date = fields.Date(string="Assign Date")
    responsible = fields.Many2one('res.users', default=lambda self: self.env.user, string="Manager", required=True)
    issue_in_vehicle = fields.Text(string="Issues in Vehicle")
    customer_observation = fields.Html(string="Customer Observation")

    vehicle_spare_part_ids = fields.One2many('vehicle.spare.part', 'job_card_id', string="Vehicle Part")
    check_list_template_id = fields.Many2one('checklist.template', string="Checklist Template", required=False)
    todo_checklist_ids = fields.One2many('todo.checklist', 'job_card_id', string="Vehicle Checklist")
    fuel_level_monitoring_ids = fields.One2many('fuel.level.monitoring', 'job_card_id', string="Fuel Level Monitoring")
    vehicle_service_image_ids = fields.One2many('vehicle.service.image', 'job_card_id', string="Vehicle Service Images")
    vehicle_service_line_ids = fields.One2many('vehicle.service.line', 'job_card_id', string="Vehicle Services")
    total_charge = fields.Monetary(string="Total Charges", compute="_total_service_charge", store=True)
    total_spare_part_price = fields.Monetary(string="Total Price", compute="_total_spare_part_price", store=True)

    invoice_count = fields.Integer(compute="_total_spare_part_price", store=True)

    part_sale_invoice_id = fields.Many2one('sale.order', string='Sale Invoice')
    sale_invoiced = fields.Monetary()

    task = fields.Selection(
        [('a_draft', "Draft"), ('b_in_diagnosis', "In Diagnosis"), ('c_supervisor_inspection', "Supervisor Inspection"),
         ('d_done', "Done")], string="Task", default='a_draft')

    def in_diagnosis(self):
        for rec in self:
            rec.task = 'b_in_diagnosis'

    def supervisor_inspection(self):
        checklist_template = True
        for rec in self.todo_checklist_ids:
            if not rec.is_done:
                checklist_template = False
                break
        if not checklist_template:
            message = {
                'type': 'ir.actions.client',
                'tag': 'display_notification',
                'params': {
                    'type': 'danger',
                    'title': ('Vehicle checklist'),
                    'message': "Please complete vehicle checklist",
                    'sticky': True,
                }
            }
            return message
        else:
            self.task = 'c_supervisor_inspection'

    def inspection_done(self):
        for rec in self:
            rec.task = 'd_done'

    @api.onchange('check_list_template_id')
    def get_checklist_items(self):
        for rec in self:
            if rec.check_list_template_id:
                checklist_items = []
                for item in rec.check_list_template_id.checklist_template_item_ids:
                    checklist_items.append((0, 0, {'title': item.name}))
                rec.todo_checklist_ids = [(5, 0, 0)]
                rec.todo_checklist_ids = checklist_items

    @api.depends('vehicle_service_line_ids')
    def _total_service_charge(self):
        for rec in self:
            total_charge = 0.0
            if rec.vehicle_service_line_ids:
                for charge in rec.vehicle_service_line_ids:
                    total_charge = total_charge + charge.service_charge
                    rec.total_charge = total_charge
            else:
                rec.total_charge = 0.0

    @api.depends('vehicle_spare_part_ids')
    def _total_spare_part_price(self):
        self.invoice_count = self.env['account.move'].search_count([('job_card_id', '=', self.id)])
        for rec in self:
            total_spare_part_price = 0.0
            if rec.vehicle_spare_part_ids:
                for spare in rec.vehicle_spare_part_ids:
                    total_spare_part_price = total_spare_part_price + spare.unit_price
                    rec.total_spare_part_price = total_spare_part_price
            else:
                rec.total_spare_part_price = 0.0

    @api.model
    def create(self, vals):
        if vals.get('job_card_number', ('New')) == ('New'):
            vals['job_card_number'] = self.env['ir.sequence'].next_by_code(
                'job.card') or ('New')
        res = super(JobCard, self).create(vals)
        return res

    def action_sale_create_invoice(self):
        total = self.total_charge + self.total_spare_part_price
        order_line = []
        for parts in self.vehicle_spare_part_ids:
            part_sale_record = {
                'product_id': parts.product_id.id,
                'product_uom_qty': parts.qty
            }
            order_line.append((0, 0, part_sale_record)),

        if self.total_charge > 0.0:
            vehicle_service = ""
            for data in self.vehicle_service_line_ids:
                vehicle_service = vehicle_service + "{} - {} {}, \n".format(data.vehicle_service_id.name,
                                                                            self.currency_id.symbol,
                                                                            data.service_charge)
            service_data = {
                'product_id': self.env.ref('tk_vehicle_repair.vehicle_service_charge').id,
                'name': vehicle_service,
                'price_unit': self.total_charge,
            }
            order_line.append((0, 0, service_data))

        data = {
            'partner_id': self.customer_id.id,
            'date_order': fields.Datetime.now(),
            'order_line': order_line,
        }
        if total > 0:
            part_sale_invoice_id = self.env['sale.order'].sudo().create(data)
            part_sale_invoice_id.job_card_id = self.id
            self.part_sale_invoice_id = part_sale_invoice_id.id
            amount_total = part_sale_invoice_id.amount_total
            self.sale_invoiced = amount_total
            return {
                'type': 'ir.actions.act_window',
                'name': 'Sale Order',
                'res_model': 'sale.order',
                'res_id': part_sale_invoice_id.id,
                'view_mode': 'form',
                'target': 'current'
            }
        else:
            message = {
                'type': 'ir.actions.client',
                'tag': 'display_notification',
                'params': {
                    'type': 'info',
                    'title': ('Sale Order Value Cannot be Zero !'),
                    'sticky': False,
                }
            }
            return message

    def action_view_invoice(self):
        return {
            "name": "Invoices",
            "type": "ir.actions.act_window",
            "res_model": "account.move",
            "view_mode": "tree,form",
            "domain": [("job_card_id", "=", self.id)],
            "context": {'default_job_card_id': self.id},
            "target": "current",
        }
