const API_KEY = "778a52b7cd6d034cbe74bf109d9ea9061f236962";
const VENDOR_ID = 4150;

export const createPayment = async (amount, orderId) => {
  const payload = {
    vendor: VENDOR_ID,
    
    // If your previous error said "Amount must be between 0.1 and 50000",
    // and you sent 300, and it failed... 
    // It's safer to send a standard float DT amount first.
    // But if you are sure about millimes, keep * 1000.
    // I will use standard float to be safe based on V2 docs.
    amount: parseFloat(amount), 

    note: `Order ${orderId}`,
    first_name: "Test",
    last_name: "Client",
    email: "test@paymee.tn",
    phone: "22222222",
    
    // CRITICAL FIX: MUST BE HTTPS
    return_url: "https://laraine-rightable-unpresumptively.ngrok-free.dev/payment/success", 
    cancel_url: "https://laraine-rightable-unpresumptively.ngrok-free.dev/payment/cart",
    webhook_url:"https://laraine-rightable-unpresumptively.ngrok-free.dev/payment/webhook",

    order_id: orderId
  };

  console.log("Sending Paymee Payload:", payload);

  try {
    const response = await fetch(
      "https://sandbox.paymee.tn/api/v2/payments/create",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": `Token ${API_KEY}`
        },
        body: JSON.stringify(payload)
      }
    );

    const data = await response.json();
    console.log("Paymee Response:", data);

    if (data.status === true && data.data?.payment_url) {
      return data.data.payment_url;
    } else {
      console.error("Paymee Rejected:", data);
      throw new Error(data.message || "Paymee failed");
    }

  } catch (error) {
    console.error("Paymee Network Error:", error);
    throw error;
  }
};
