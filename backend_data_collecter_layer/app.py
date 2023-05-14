from flask import Flask, request, jsonify
import csv

app = Flask(__name__)


@app.route("/add", methods=['POST'])
def add_transaction():
    if request.method == 'POST':
        data = request.get_json()

        try:
            address = data['address']
            item_name = data['item_name']
            item_type = data['item_type']
            country = data['country']
            shop_name = data['shop_name']

        except Exception as e:
            return jsonify({'message': 'not enough data or invalid data'}), 403

        file = open('transactions.csv', mode='a', encoding='utf-8')
        writer = csv.writer(file)
        row = [address, item_name, item_type, shop_name, country]
        writer.writerow(row)
        file.close()

        print('row_added: ', row)

        # Return a response indicating success
        return jsonify({'message': 'Data processed successfully'}), 200
