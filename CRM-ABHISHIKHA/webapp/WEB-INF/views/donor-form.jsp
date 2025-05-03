<style>
    .donor-form-container {
        max-width: 600px;
        margin: 30px auto;
        padding: 25px;
        background-color: #f9f9f9;
        border-radius: 12px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        font-family: 'Segoe UI', sans-serif;
    }

    .donor-form-container h2 {
        margin-bottom: 20px;
        font-size: 24px;
        color: #333;
        text-align: center;
    }

    .donor-form-container input[type="text"],
    .donor-form-container input[type="email"],
    .donor-form-container textarea {
        width: 100%;
        padding: 12px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 8px;
        box-sizing: border-box;
        font-size: 14px;
    }

    .donor-form-container textarea {
        resize: vertical;
    }

    .donor-form-container button {
        background-color: #0d5a45;
        color: white;
        padding: 12px 20px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 16px;
        width: 100%;
        transition: background-color 0.3s ease;
    }

    .donor-form-container button:hover {
        background-color: #0d5a45de;
    }
</style>

<div class="donor-form-container">
    <h2>Add Donor</h2>
    <form action="${pageContext.request.contextPath}/DonorFormS" method="post">
        <input type="text" name="name" placeholder="Full Name" required>
        <input type="text" name="phone" placeholder="Phone Number" required>
        <input type="email" name="email" placeholder="Email Address">
        <input type="text" name="pan" placeholder="PAN Number">
        <textarea name="address" placeholder="Address" rows="3"></textarea>
        <button type="submit">Save Donor</button>
    </form>
</div>
