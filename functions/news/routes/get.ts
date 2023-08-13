import { Context, HttpRequest } from "@azure/functions";
import { badRequest, ok } from "./responses";

export async function get(context: Context, req: HttpRequest) {
  const name = req.query.name || (req.body && req.body.name);
  if (!name) {
    return badRequest(
      context,
      "Please pass a name on the query string or in the request body"
    );
  }
  return ok(context, {
    message: `Hello, ${name}. This HTTP triggered function executed successfully.`,
  });
}
