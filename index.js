// @flow

const parser = require('./peg/mysql.js');
console.log(parser.parse('SELECT * FROM HOGE'));
