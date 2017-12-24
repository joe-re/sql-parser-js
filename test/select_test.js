import test from 'ava'
const parser = require('../peg/mysql.js');

test('basic query', t => {
  const result = parser.parse('SELECT HOGE.hoge FROM HOGE')
  t.deepEqual(result, {
    type: 'select',
    columns: { type: 'column_ref', table: 'HOGE', column: 'hoge' },
    from: 'HOGE',
    where: null
  });
});

test('using *', t => {
  const result = parser.parse('SELECT * FROM HOGE')
  t.deepEqual(result, {
    type: 'select',
    columns: { type: 'star' },
    from: 'HOGE',
    where: null
  });
});

test('where', t => {
  const result = parser.parse('SELECT * FROM HOGE WHERE 1 <= 1')
  console.log(result.where)
  t.deepEqual(result, {
    type: 'select',
    columns: { type: 'star' },
    from: 'HOGE',
    where: {
      conditions: [ { left: 1, op: 'LessThanEqual', right: 1 } ]
    }
  });
});
