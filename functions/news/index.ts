import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import { get, notAllowed } from "../routes";

const httpTrigger: AzureFunction = async function (
  context: Context,
  req: HttpRequest
): Promise<void> {
  context.log("API KEY", process.env.NODE_NEWS_API_KEY);
  context.log("API KEY[]", process.env["NODE_NEWS_API_KEY"]);

  switch (req.method) {
    case "GET":
      await get(context, req);
      break;
    default:
      notAllowed(context, req.method);
  }
};

export default httpTrigger;
