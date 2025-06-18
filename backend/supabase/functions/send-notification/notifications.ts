import { connect } from "node:http2";

import { NotificationPayload } from "./types.ts";
import { BUNDLE_ID, getAuthTokenFromAPN } from "./apns.ts";
import { fetchRegisteredDevices } from "./db.ts";
import { RegisteredDevice } from "./types.ts";

const APNS_DEVELOPMENT_URL = "api.sandbox.push.apple.com";
const BATCH_SIZE = 100;

async function  sendIosNotification(
  deviceToken: string,
  payload: NotificationPayload,
  authToken: string
): Promise<{
  success: boolean;
  deviceToken: string;
  status?: number;
  error?: string;
}> {
  return new Promise((resolve, reject) => {
    try {
      const client = connect(`https://${APNS_DEVELOPMENT_URL}`);

      client.on("error", (err) => {
        reject({
          success: false,
          deviceToken,
          error: err instanceof Error ? err.message : String(err),
        });
      });

      const notificationPayload = {
        aps: {
          alert: {
            title: payload.title,
            body: payload.body,
          },
          sound: "default",
          badge: 1,
          "mutable-content": 1,
          "content-available": 1,
          priority: 10,
          category: "message",
        },
        ...payload.data,
      };

      const req = client.request({
        ":method": "POST",
        ":scheme": "https",
        ":path": `/3/device/${deviceToken}`,
        "apns-topic": BUNDLE_ID,
        authorization: `bearer ${authToken}`,
        "content-type": "application/json",
      });

      req.setEncoding("utf8");

      req.on("response", (headers) => {
        const status = headers[":status"] as number;

        let responseData = "";

        req.on("data", (chunk) => {
          responseData += chunk;
        });

        req.on("end", () => {
          if (status === 200) {
            resolve({ success: true, deviceToken, status });
          } else {
            reject({
              success: false,
              deviceToken,
              status,
              error: responseData,
            });
          }
        });
      });

      req.write(JSON.stringify(notificationPayload));
      req.end();
    } catch (error) {
      reject({
        success: false,
        deviceToken,
        error: error instanceof Error ? error.message : String(error),
      });
    }
  });
}

export async function sendNotification(payload: NotificationPayload) {
  const results = {
    ios: { success: 0, failed: 0, errors: [] as any[] },
  };

  try {
    // const iosDevices = await fetchRegisteredDevices();
    const iosDevices = [
      {
        id: 1,
        device_token: "d883df92aeaea058f18091e5689071e1961c57f644190579bcda7a1ac1acbe72",
        device_type: "ios",
        enabled_notifications: true,
        created_at: new Date().toISOString(),
      },
    ]

    if (iosDevices.length > 0) {
      const apnsToken = await getAuthTokenFromAPN();

      for (let i = 0; i < iosDevices.length; i += BATCH_SIZE) {
        const batch = iosDevices.slice(i, i + BATCH_SIZE);
        const batchResults = await Promise.all(
          batch.map((device) =>
            sendIosNotification(device.device_token, payload, apnsToken)
          )
        );

        batchResults.forEach((result) => {
          if (result.success) {
            results.ios.success++;
          } else {
            results.ios.failed++;
            results.ios.errors.push(result.error);
          }
        });
      }
    }

    return results;
  } catch (error) {
    console.error("[Notifications] Error in notification dispatch:", error);
    throw error;
  }
}