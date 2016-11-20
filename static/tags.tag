<!-- vi: set ft=html nu noet ts=2 sw=2 : -->
<blaze-modal>
	<div class="c-overlay c-overlay--dismissable" if="{visible}" onclick="{on_bg_clicked}"></div>
	<div class="o-modal" if="{visible}">
		<div class="c-card">
			<header class="c-card__header">
				<yield from="header" />
			</header>
			<div class="c-card__body">
				<yield from="body" />
			</div>
			<footer class="c-card__footer">
				<yield from="footer" />
			</footer>
		</div>
	</div>

	<script>
		this.visible = false;

		this.show = function () { this.visible = true;  this.update(); }
		this.hide = function () { this.visible = false; this.update(); }

		on_bg_clicked() {
			this.hide();
		}
	</script>
</blaze-modal>

<blaze-modal-form>
	<div class="c-overlay c-overlay--dismissable" if="{visible}" onclick="{on_bg_clicked}"></div>
	<div class="o-modal" if="{visible}">
		<form onsubmit="{on_submit}" autocomplete="off">
			<div class="c-card">
				<header class="c-card__header">
					<yield from="header" />
				</header>
				<div class="c-card__body">
					<yield from="body" />
				</div>
				<footer class="c-card__footer">
					<yield from="footer" />
				</footer>
			</div>
		</form>
	</div>

	<script>
		var self = this;

		this.visible = false;

		this.show = function () { self.visible = true;  self.update(); }
		this.hide = function () { self.visible = false; self.update(); }
		this.submit = function () {
			self.hide();
			self.trigger('submitted');
		}

		on_submit() {
			this.submit();
		}

		on_bg_clicked() {
			this.hide();
		}
	</script>
</blaze-modal-form>

<blaze-drawer>
	<div class="c-overlay c-overlay--dismissable" if="{visible}" onclick="{on_bg_clicked}"></div>
	<div class="o-drawer u-highest o-drawer--top o-drawer--visible" if="{visible}">
		<div class="c-card">
			<header class="c-card__header">
				<yield from="header" />
			</header>
			<div class="c-card__body">
				<yield from="body" />
			</div>
			<footer class="c-card__footer">
				<yield from="footer" />
			</footer>
		</div>
	</div>

	<script>
		this.visible = false;

		this.show = function () { this.visible = true; }
		this.hide = function () { this.visible = false; }

		on_bg_clicked() {
			this.hide();
		}
	</script>
</blaze-drawer>

<confirm-dialog>
	<blaze-modal message="{message}" on_yes_clicked="{on_yes_clicked}" on_no_clicked="{on_no_clicked}">
		<yield to="header">
			<h2 class="c-heading">Confirmation</h2>
		</yield>
		<yield to="body">
			{opts.message}
		</yield>
		<yield to="footer">
			<div class="c-input-group">
				<button class="c-button c-button--block c-button--error" onclick="{opts.on_yes_clicked}">Yes</button>
				<button class="c-button c-button--block" onclick="{opts.on_no_clicked}">No</button>
			</div>
		</yield>
	</blaze-modal>

	<script>
		on_yes_clicked() {
			this.tags['blaze-modal'].hide();
			this.trigger('confirmed');
		}

		on_no_clicked() {
			this.tags['blaze-modal'].hide();
		}

		this.show = function (message) {
			this.message = message;
			this.tags['blaze-modal'].show();
		}
	</script>
</confirm-dialog>

<otp-dialog>
	<blaze-modal name="modal" otp="{params.otp}" message="{params.message}" on_close_clicked="{on_close_clicked}">
		<yield to="header">
			<h2 class="c-heading">OTP</h2>
		</yield>
		<yield to="body">
			{opts.message}
			<div class="u-center-block" style="height: 6em; background-color: #bbb;">
				<div class="u-center-block__content u-super">{opts.otp}</div>
			</div>
		</yield>
		<yield to="footer">
			<div class="c-input-group">
				<button class="c-button c-button--block" onclick="{opts.on_close_clicked}">Close</button>
			</div>
		</yield>
	</blaze-modal>

	<script>
		var self = this;

		on_close_clicked() {
			this.tags.modal.hide();
		}

		this.show = function (params) {
			self.params = params;
			self.tags.modal.show();
		}
	</script>
</otp-dialog>

<qr-dialog>
	<blaze-modal name="modal" on_close_clicked="{on_close_clicked}">
		<yield to="header">
			<h2 class="c-heading">Provisioning QRCode</h2>
		</yield>
		<yield to="body">
			<div class="u-center-block" style="height: 6em">
				<div class="u-center-block__content u-super"><img id="qrimg" /></div>
			</div>
		</yield>
		<yield to="footer">
			<div class="c-input-group">
				<button class="c-button c-button--block" onclick="{opts.on_close_clicked}">Close</button>
			</div>
		</yield>
	</blaze-modal>

	<script>
		var self = this;

		on_close_clicked() {
			this.tags.modal.hide();
		}

		this.show = function (qrurl) {
			self.tags.modal.qrimg.src = qrurl;
			self.tags.modal.show();
		}
	</script>
</qr-dialog>

<edit-entry-dialog>
	<blaze-modal-form name="modal" on_submit_clicked="{on_submit_clicked}" on_close_clicked="{on_close_clicked}">
		<yield to="header">
			<h2 class="c-heading">Entry</h2>
		</yield>
		<yield to="body">
			<fieldset class="o-fieldset">
				<label class="c-label o-form-element">
					Issuer:
					<input type="text" id="issuer" class="c-field c-field--label" />
				</label>
				<label class="c-label o-form-element">
					Account:
					<input type="text" id="account" class="c-field c-field--label" />
				</label>
				<label class="c-label o-form-element">
					Secret:
					<input type="text" id="secret" class="c-field c-field--label" />
				</label>
			</fieldset>
		</yield>
		<yield to="footer">
			<div class="c-input-group">
				<button class="c-button c-button--block c-button--brand" onclick="{opts.on_submit_clicked}">Submit</button>
				<button class="c-button c-button--block" onclick="{opts.on_close_clicked}">Close</button>
			</div>
		</yield>
	</blaze-modal-form>

	<script>
		var self = this;

		on_submit_clicked() {
			this.tags.modal.submit();
		}

		on_close_clicked() {
			this.tags.modal.hide();
		}

		this.tags.modal.on('submitted', function () {
			self.trigger('submitted', {
				issuer: self.tags.modal.issuer.value,
				account: self.tags.modal.account.value,
				secret: self.tags.modal.secret.value
			});
		});

		this.show = function (entry) {
			var modal = this.tags.modal;
			modal.issuer.value = entry.issuer;
			modal.account.value = entry.account;
			modal.secret.value = entry.secret;
			modal.update();
			modal.show();
			modal.issuer.select();
			modal.issuer.focus();
		}
	</script>
</edit-entry-dialog>

<actionmenu>
	<blaze-drawer name="drawer" text="{text}" on_otp_clicked="{on_otp_clicked}" on_qr_clicked="{on_qr_clicked}" on_edit_clicked="{on_edit_clicked}" on_remove_clicked="{on_remove_clicked}">
		<yield to="header">
			<h2 class="c-heading">Select action</h2>
		</yield>
		<yield to="body">
			{opts.text}
		</yield>
		<yield to="footer">
			<div class="c-input-group">
				<button class="c-button c-button--block c-button--success" onclick="{opts.on_otp_clicked}"><i class="fa fa-key"></i> OTP</button>
				<button class="c-button c-button--block c-button--warning" onclick="{opts.on_qr_clicked}"><i class="fa fa-qrcode" aria-hidden="true"></i> Show QR</button>
				<button class="c-button c-button--block c-button--info" onclick="{opts.on_edit_clicked}"><i class="fa fa-edit" aria-hidden="true"></i> Edit</button>
				<button class="c-button c-button--block c-button--error" onclick="{opts.on_remove_clicked}"><i class="fa fa-trash" aria-hidden="true"></i> Remove</button>
			</div>
		</yield>
	</blaze-drawer>

	<otp-dialog name="otp_dialog"></otp-dialog>
	<qr-dialog name="qr_dialog"></qr-dialog>
	<edit-entry-dialog name="edit_entry_dialog"></edit-entry-dialog>
	<confirm-dialog name="confirm_remove_dialog"></confirm-dialog>

	<script>
		var self = this;

		on_otp_clicked() {
			this.hide();
			this.opts.model.fetch_otp(this.target_entry.index);
		}

		on_qr_clicked() {
			this.hide();
			this.tags.qr_dialog.show(this.opts.model.qr());
		}

		on_edit_clicked() {
			this.hide();
			this.opts.model.get(this.target_entry.index);
		}

		on_remove_clicked() {
			this.hide();

			this.tags.confirm_remove_dialog.show('Are you sure you want to remove "' + this.target_entry.text + '"?');
		}

		this.tags.edit_entry_dialog.on('submitted', function (form) {
			self.opts.model.set(self.target_entry.index, form.issuer, form.account, form.secret);
		});

		this.tags.confirm_remove_dialog.on('confirmed', function () {
			self.opts.model.remove(self.target_entry.index);
		});

		this.show = function (target_entry) {
			self.target_entry = target_entry;

			self.text = "target: " + target_entry.account + " on " + target_entry.issuer;

			self.tags.drawer.show();
		}

		this.hide = function () {
			self.tags.drawer.hide();
		}

		this.opts.model.on('item_fetched', function (entry) {
			self.tags.edit_entry_dialog.show({
				issuer: entry.issuer,
				account: entry.account,
				secret: entry.secret
			});
		});

		this.opts.model.on('otp_fetched', function (otp) {
			var target_entry = self.target_entry;

			self.tags.otp_dialog.show({
				message: "OTP for " + target_entry.account + " on " + target_entry.issuer,
				otp: otp.otp
			});
		});
	</script>
</actionmenu>

<app>
	<button class="c-button" onclick="{on_add_entry_clicked}" style="margin-top: 1em; margin-bottom: 1em;"><i class="fa fa-plus-square"></i> Add</button>

	<table class="c-table c-table--clickable">
		<thead class="c-table__head">
			<tr class="c-table__row c-table__row--heading">
				<th class="c-table__cell">Issuer</th>
				<th class="c-table__cell">Account</th>
			</tr>
		</thead>
		<tbody class="c-table__body">
			<tr class="c-table__row" each="{entries}" onclick="{on_entry_clicked}">
				<td class="c-table__cell">{issuer}</td>
				<td class="c-table__cell">{account}</td>
			</tr>
		</tbody>
	</table>

	<actionmenu model="{opts.model}"></actionmenu>

	<edit-entry-dialog name="edit_entry_dialog"></edit-entry-dialog>

	<script>
		var self = this;

		on_entry_clicked(e) {
			this.tags.actionmenu.show(e.item);
		}

		on_add_entry_clicked(e) {
			this.tags.edit_entry_dialog.show({ issuer: "", account: "", secret: "" });
		}

		this.tags.edit_entry_dialog.on('submitted', function (form) {
			self.opts.model.add(form.issuer, form.account, form.secret);
		});

		this.opts.model.on('updated', function () {
			self.opts.model.load_items();
		});

		this.opts.model.on('items_fetched', function () {
			self.update({ entries: self.opts.model.items() });
		});

		this.opts.model.load_items();
	</script>
</app>
