// Q1
db.orders.countDocuments({})

// Q2
db.orders.aggregate([
    { $group: { _id: null, totalAmount: { $sum: "$amount" } } }
])

// Q3
db.orders.aggregate([
    { $group: { _id: "$status", count: { $sum: 1 } } }
])

// Q4
db.orders.aggregate([
    { $group: { _id: "$cust_id", totalSpending: { $sum: "$amount" } } }
])

// Q5
db.orders.aggregate([
    { $group: { _id: "$cust_id", avgAmount: { $avg: "$amount" } } }
])

// Q6
db.orders.aggregate([
    { $group: { _id: "$cust_id", totalSpending: { $sum: "$amount" } } },
    { $match: { totalSpending: { $gt: 200 } } }
])

// Q7
db.orders.aggregate([
    { $group: { _id: "$cust_id", totalSpending: { $sum: "$amount" } } },
    { $sort: { totalSpending: -1 } }
])

// Q8
db.items.aggregate([
    { $group: { _id: null, totalQuantity: { $sum: "$qty" } } }
])

// Q9
db.customers.aggregate([
    { $lookup: { from: "orders", localField: "_id", foreignField: "cust_id", as: "orders" } }
])

// Q10
db.orders.aggregate([
    { $lookup: { from: "customers", localField: "cust_id", foreignField: "_id", as: "customer_details" } },
    { $unwind: "$customer_details" },
    { $project: { _id: 1, customerName: "$customer_details.name", amount: 1, status: 1 } }
])

// Q11
db.orders.aggregate([
    { $group: { _id: "$cust_id", totalSpending: { $sum: "$amount" } } },
    { $lookup: { from: "customers", localField: "_id", foreignField: "_id", as: "customer_details" } },
    { $unwind: "$customer_details" },
    { $project: { _id: 0, customerName: "$customer_details.name", totalSpending: 1 } }
])

// Q12
db.customers.aggregate([
    { $lookup: { from: "orders", localField: "_id", foreignField: "cust_id", as: "orders" } },
    { $match: { "orders.0": { $exists: true } } }
])

// Q13
db.customers.aggregate([
    { $lookup: { from: "orders", localField: "_id", foreignField: "cust_id", as: "orders" } },
    { $match: { orders: { $size: 0 } } }
])

// Q14
db.orders.aggregate([
    { $lookup: { from: "items", localField: "_id", foreignField: "order_id", as: "items" } },
    { $unwind: "$items" },
    { $group: { _id: "$items.product", totalQuantitySold: { $sum: "$items.qty" } } }
])

// Q15
db.customers.aggregate([
    { $lookup: { from: "orders", localField: "_id", foreignField: "cust_id", as: "orders" } },
    { $unwind: "$orders" },
    { $lookup: { from: "items", localField: "orders._id", foreignField: "order_id", as: "items" } },
    { $unwind: "$items" },
    { $group: { _id: "$_id", customerName: { $first: "$name" }, totalQuantity: { $sum: "$items.qty" } } },
    { $sort: { totalQuantity: -1 } },
    { $limit: 1 }
])