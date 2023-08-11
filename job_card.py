# -*- coding: utf-8 -*-
# Copyright 2022-Today TechKhedut.
# Part of TechKhedut. See LICENSE file for full copyright and licensing details.
from odoo import models, fields, api, _
from odoo.exceptions import ValidationError

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

    @api.model
    def create_job_card(self):
        # Here you can add the logic to create a new job card
        pass

   
