import { Context } from "@azure/functions";

export function ok(context: Context, body: any) {
  context.res = {
    status: 200,
    body,
  };
}

export function badRequest(context: Context, body?: any) {
  context.res = {
    status: 400,
    body: "Bad Request" + body ? `: ${body}` : "",
  };
}

export function notFound(context: Context, body?: any) {
  context.res = {
    status: 404,
    body: "Not Found" + body ? `: ${body}` : "",
  };
}

export function notAllowed(context: Context, body?: any) {
  context.res = {
    status: 405,
    body: "Method Not Allowed" + body ? `: ${body}` : "",
  };
}

export function internalServerError(context: Context, body?: any) {
  context.res = {
    status: 500,
    body: "Internal Server Error" + body ? `: ${body}` : "",
  };
}
