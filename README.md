Все задачи решаются в Redash.
Но также 


На схеме ниже показаны связи между таблицами

![ER](https://github.com/Nnastyavas/Karpov.courses.SQL_simulator/blob/main/ER_karpov.png)

### Таблица <kbd>user_actions</kbd>
Содержит данные о действиях пользователей с заказами.

<table>
  <tr>
    <th>Столбец</th>
    <th>Тип данных</th>
    <th>Описание</th>
  </tr>
  <tr>
    <td>user_id</td>
    <td>INT</td>
    <td>id пользователя</td>
  </tr>
  <tr>
    <td>order_id</td>
    <td>INT</td>
    <td>id заказа</td>
  </tr>
  <tr>
    <td>action</td>
    <td>VARCHAR(50)</td>
    <td>Действие пользователя с заказом; 'create_order' — создание заказа, 'cancel_order' — отмена заказа</td>
  </tr>
  <tr>
    <td>time</td>
    <td>TIMESTAMP</td>
    <td>Время совершения действия</td>
  </tr>
</table>

### Таблица <kbd>courier_actions</kbd>
Содержит данные о действиях курьеров с заказами.

<table>
  <tr>
    <th>Столбец</th>
    <th>Тип данных</th>
    <th>Описание</th>
  </tr>
  <tr>
    <td>courier_id</td>
    <td>INT</td>
    <td>id курьера</td>
  </tr>
  <tr>
    <td>order_id</td>
    <td>INT</td>
    <td>id заказа</td>
  </tr>
  <tr>
    <td>action</td>
    <td>VARCHAR(50)</td>
    <td>Действие курьера с заказом; 'accept_order' — принятие заказа, 'deliver_order' — доставка заказа</td>
  </tr>
  <tr>
    <td>time</td>
    <td>TIMESTAMP</td>
    <td>Время совершения действия</td>
  </tr>
</table>

### Таблица <kbd>orders</kbd>
Содержит информацию о заказах.

<table>
  <tr>
    <th>Столбец</th>
    <th>Тип данных</th>
    <th>Описание</th>
  </tr>
  <tr>
    <td>order_id</td>
    <td>INT</td>
    <td>id заказа</td>
  </tr>
  <tr>
    <td>creation_time</td>
    <td>TIMESTAMP</td>
    <td>Время создания заказа</td>
  </tr>
  <tr>
    <td>product_ids</td>
    <td>integer[]</td>
    <td>Список id товаров в заказе</td>
  </tr>
</table>

### Таблица <kbd>users</kbd>
Содержит информацию о пользователях.

<table>
  <tr>
    <th>Столбец</th>
    <th>Тип данных</th>
    <th>Описание</th>
  </tr>
  <tr>
    <td>user_id </td>
    <td>INT </td>
    <td>id пользователя</td>
  </tr>
  <tr>
    <td>birth_date </td>
    <td>DATE</td>
    <td>Дата рождения</td>
  </tr>
  <tr>
    <td>sex </td>
    <td>VARCHAR(50)</td>
    <td>Пол; 'male' — мужской, 'female' — женский</td>
  </tr>
</table>

### Таблица <kbd>couriers</kbd>
Содержит информацию о курьерах.

<table>
  <tr>
    <th>Столбец</th>
    <th>Тип данных</th>
    <th>Описание</th>
  </tr>
  <tr>
    <td>courier_id </td>
    <td>INT </td>
    <td>id курьера</td>
  </tr>
  <tr>
    <td>birth_date </td>
    <td>DATE</td>
    <td>Дата рождения</td>
  </tr>
  <tr>
    <td>sex </td>
    <td>VARCHAR(50)</td>
    <td>Пол; 'male' — мужской, 'female' — женский</td>
  </tr>
</table>

### Таблица <kbd>products</kbd>
Содержит информацию о товарах, которые доставляет сервис.

<table>
  <tr>
    <th>Столбец</th>
    <th>Тип данных</th>
    <th>Описание</th>
  </tr>
  <tr>
    <td>product_id </td>
    <td>INT </td>
    <td>id продукта</td>
  </tr>
  <tr>
    <td>name </td>
    <td>VARCHAR(50)</td>
    <td>Название товара</td>
  </tr>
  <tr>
    <td>price</td>
    <td>FLOAT(4)</td>
    <td>Цена товара</td>
  </tr>
</table>
