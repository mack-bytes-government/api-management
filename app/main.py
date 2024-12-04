from flask import Flask, request, jsonify
import random

app = Flask(__name__)

@app.route('/random', methods=['GET'])
def random_number():
    try:
        min_val = int(request.args.get('min', 0))
        max_val = int(request.args.get('max', 100))
        if min_val > max_val:
            return jsonify({"error": "min should be less than or equal to max"}), 400
        random_num = random.randint(min_val, max_val)
        return jsonify({"random_number": random_num})
    except ValueError:
        return jsonify({"error": "Invalid input"}), 400

if __name__ == '__main__':
    app.run(debug=True)