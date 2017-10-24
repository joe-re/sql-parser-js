// @flow

const parser = require('./peg/mysql.js');
try {
  console.log(parser.parse('SELECT HOGE.hoge FROM HOGE'));
} catch (e) {
  console.log(e);
}
