import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import { get, notAllowed } from "./routes";

const httpTrigger: AzureFunction = async function (
  context: Context,
  req: HttpRequest
): Promise<void> {
  switch (req.method) {
    case "GET":
      await get(context, req);
      break;
    default:
      notAllowed(context, req.method);
  }
};

export default httpTrigger;
