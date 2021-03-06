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
  t.deepEqual(result, {
    type: 'select',
    columns: { type: 'star' },
    from: 'HOGE',
    where: {
      conditions: [ { left: 1, op: 'LessThanEqual', right: 1 } ]
    }
  });
});

test('column ref in where exp', t => {
  const result = parser.parse('SELECT * FROM HOGE WHERE HOGE.hoge <= 1')
  t.deepEqual(result, {
    type: 'select',
    columns: { type: 'star' },
    from: 'HOGE',
    where: {
      conditions: [
        {
          left: { column: 'hoge', table: 'HOGE', type: 'column_ref' },
          op: 'LessThanEqual',
          right: 1
        }
      ]
    }
  });
});
