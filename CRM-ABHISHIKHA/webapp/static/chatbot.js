const chatbotToggler = document.querySelector(".chatbot-toggler");
const closeBtn = document.querySelector(".close-btn");
const chatbox = document.querySelector(".chatbox");
const chatInput = document.querySelector(".chat-input textarea");
const sendChatBtn = document.querySelector(".chat-input span");
let userMessage = null; // Variable to store user's message
const inputInitHeight = chatInput.scrollHeight;
let isRasaServerReady = false; // Flag to check server status
let botStatusMessage;
let greetMessage;

// Function to create chat list item
const createChatLi = (message, className) => {
  const chatLi = document.createElement("li");
  chatLi.classList.add("chat", `${className}`);
  let chatContent =
    className === "outgoing"
      ? `<p></p>`
      : `<span class="material-symbols-outlined">smart_toy</span><p></p>`;
  chatLi.innerHTML = chatContent;
  chatLi.querySelector("p").textContent = message;
  return chatLi;
};

// Function to check Rasa server status
const checkRasaServer = async () => {
  try {
    const response = await fetch("http://localhost:5005/status");
    if (response.ok) {
      isRasaServerReady = true;
	  
      sendChatBtn.disabled = false; // Enable send button
      if (botStatusMessage) {
        botStatusMessage.querySelector("p").textContent = "Bot is Online!";
		greetMessage = createChatLi("Hi there, How can I help you today?", "incoming");
      	chatbox.appendChild(greetMessage);
      	chatbox.scrollTo(0, chatbox.scrollHeight);
      } else{
			greetMessage = createChatLi("Hi there, How can I help you today?", "incoming");
	      	chatbox.appendChild(greetMessage);
	      	chatbox.scrollTo(0, chatbox.scrollHeight);
	  }
    } else {
      throw new Error("Rasa server not ready.");
    }
  } catch (error) {
    console.error(error);
    sendChatBtn.disabled = true; // Disable send button
    if (!botStatusMessage) {
      botStatusMessage = createChatLi("Bot is starting ...", "incoming");
      chatbox.appendChild(botStatusMessage);
      chatbox.scrollTo(0, chatbox.scrollHeight);
    }
    setTimeout(checkRasaServer, 2000); // Retry after 2 seconds
  }
};

// Function to generate response from the bot
const generateResponse = async (chatElement) => {
  const messageElement = chatElement.querySelector("p");

  const requestOptions = {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ sender: "user", message: userMessage }),
  };

  try {
    const response = await fetch(
      "http://localhost:5005/webhooks/rest/webhook",
      requestOptions
    );
    const data = await response.json();

    if (!response.ok) throw new Error("Bot response failed.");

    const botReply = data.map((res) => res.text).join("\n");
    messageElement.textContent = botReply || "No reply from bot.";
  } catch (error) {
    messageElement.classList.add("error");
    messageElement.textContent = error.message;
  } finally {
    chatbox.scrollTo(0, chatbox.scrollHeight);
  }
};

// Function to handle chat input
const handleChat = () => {
  if (!isRasaServerReady) {
    return;
  } else {
    userMessage = chatInput.value.trim();
    if (!userMessage) return;
    chatInput.value = "";
    chatInput.style.height = `${inputInitHeight}px`;
    chatbox.appendChild(createChatLi(userMessage, "outgoing"));
    chatbox.scrollTo(0, chatbox.scrollHeight);

    setTimeout(() => {
      const incomingChatLi = createChatLi("Thinking...", "incoming");
      chatbox.appendChild(incomingChatLi);
      chatbox.scrollTo(0, chatbox.scrollHeight);
      generateResponse(incomingChatLi);
    }, 600);
  }
};

// Adjust chat input height dynamically
chatInput.addEventListener("input", () => {
  chatInput.style.height = `${inputInitHeight}px`;
  chatInput.style.height = `${chatInput.scrollHeight}px`;
});

// Handle Enter key for sending messages
chatInput.addEventListener("keydown", (e) => {
  if (e.key === "Enter" && !e.shiftKey && window.innerWidth > 800) {
    e.preventDefault();
    handleChat();
  }
});

// Event listeners for buttons
sendChatBtn.addEventListener("click", handleChat);
closeBtn.addEventListener("click", () =>
  document.body.classList.remove("show-chatbot")
);
chatbotToggler.addEventListener("click", () =>
  document.body.classList.toggle("show-chatbot")
);

// Start checking Rasa server status on page load
checkRasaServer();
