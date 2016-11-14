<!-- vi: set noet ts=2 sw=2 : -->
(function (global, riot, axios) {
	var model = {
		_items: [],

		items: function () {
			return this._items;
		},

		load_items: function () {
			var self = this;
			axios.get('/entry/')
				.then(function (res) {
					self._items = res.data.entries;
					self.trigger('items_fetched');
				});
		},

		get: function (index) {
			var self = this;
			axios.get('/entry/' + index)
				.then(function (res) {
					self.trigger('item_fetched', res.data);
				});
		},

		add: function (issuer, account, secret) {
			var self = this;
			axios.post('/entry/', { issuer: issuer, account: account, secret: secret })
				.then(function (res) {
					self.trigger('updated');
				});
		},

		set: function (index, issuer, account, secret) {
			var self = this;
			axios.put('/entry/' + index, { issuer: issuer, account: account, secret: secret })
				.then(function (res) {
					self.trigger('updated');
				});
		},

		remove: function (index) {
			var self = this;
			axios.delete('/entry/' + index)
				.then(function (res) {
					self.trigger('updated');
				});
		},

		fetch_otp: function (index) {
			var self = this;
			axios.get('/entry/' + index + '/otp')
				.then(function (res) {
					self.trigger('otp_fetched', res.data);
				});
		},

		qr: function (index) {
			return '/entry/' + index + '/provision/qr.png';
		}
	};

	riot.observable(model);

	global.model = model;
})(window, window.riot, window.axios);
