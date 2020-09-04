const webpack = require('webpack');
const path = require('path');

const config = {
	entry: './src/index.js',
	mode: 'production',
	performance: {
		hints: false
	},
	output: {
		path: path.resolve(__dirname, 'dist'),
	}
};

module.exports = config;
