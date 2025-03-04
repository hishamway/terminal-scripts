import { createClient } from "redis";
import dotenv from "dotenv";
// Load environment variables from .env file
dotenv.config();

// Create Redis client
const client = createClient({ host: process.env.REDIS_HOST, port: process.env.REDIS_PORT });

// Connect to Redis
client.on("connect", () => {
  console.log("Connected to Redis.");
});

// Handle Redis errors
client.on("error", (err) => {
  console.error("Redis error:", err);
  // Exit the process to let PM2 restart it
  process.exit(1);
});

await client.connect();

// Function to check and update keys
async function updateAgentCallMap() {
  try {
    // Fetch all agentCallMap keys
    const agentCallMapKeys = await client.keys(process.env.ASTERISK_STASIS_APP + ":agentCallMap:*");

    if (!agentCallMapKeys.length) {
      console.log("No agent mappings.");
      return;
    }
    for (const key of agentCallMapKeys) {
      console.log("🚀 ~ updateAgentCallMap ~ key:", key)
      const agentCallIds = await client.get(key); // Get the agentCallIds of the agentCallMap key
      if (!agentCallIds) continue;
      console.log("updateAgentCallMap ~ agentCallIds:", agentCallIds);

      // Split the agentCallIds into call IDs
      const callIds = agentCallIds.split(",");
      const validCallIds = [];

      for (const callId of callIds) {
        const callDetailsKey = `${process.env.ASTERISK_STASIS_APP}:calls:${callId.slice(1, -1)}:details`;

        console.log("🚀 ~ updateAgentCallMap ~ callDetailsKey:", callDetailsKey)
        // Check if the call details key exists in Redis
        const callDetailsExists = await client.keys(callDetailsKey);
        console.log("🚀 ~ updateAgentCallMap ~ callDetailsExists:", callDetailsExists)

        if (callDetailsExists.length > 0) {
          validCallIds.push(callId); // Add the call ID to the valid list if its details key exists
        }
      }

      // If the valid call IDs differ from the current agentCallIds, update the Redis key
      const updatedValue = validCallIds.join(",");
      console.log("🚀 ~ updateAgentCallMap ~ updatedValue:", updatedValue)
      if (updatedValue !== agentCallIds) {
        console.log(`Deleting key ${key}`);
        // await client.del(key);
      }
    }
  } catch (err) {
    console.error("Error updating agentCallMap:", err);
  }
}

// Run the update every 10 seconds
setInterval(updateAgentCallMap, 30000);
