import { Context, HttpRequest } from "@azure/functions";
import { badRequest, ok } from "./responses";
import { companies } from "../common";

import axios from "axios";

export async function get(context: Context, req: HttpRequest) {
  let ticker = req.query.ticker;
  if (!ticker) {
    badRequest(
      context,
      "Ticker is required\n\nAvailable tickers: " +
        companies.map((c) => c.ticker).join(", ")
    );
    return;
  }

  ticker = ticker.toUpperCase();

  const company = companies.find((c) => c.ticker === ticker);
  if (!company) {
    badRequest(
      context,
      "Ticker not found\n\nAvailable tickers: " +
        companies.map((c) => c.ticker).join(", ")
    );
    return;
  }

  const query = req.query.query || company.query;

  const articles = await getNewsByTicker(query);

  if (articles === "error") {
    badRequest(context, "Error fetching news");
    return;
  }

  return ok(context, articles);
}

async function getNewsByTicker(query: string) {
  const url = "https://api.newscatcherapi.com/v2/search";
  try {
    const response = await axios.get(url, {
      params: {
        q: query,
        lang: "no,sv,da,de,en",
        sort_by: "relevancy",
        page: 1,
      },
      headers: {
        "x-api-key":
          process.env.NEWS_API_KEY ||
          "MDOnXm6aR51STF6zADy48yO7ycNCF3_Z1somm4BkYl4",
      },
    });

    const data = response.data;

    if (data.status !== "ok") {
      console.log(data.message);
      return "error";
    }

    const articles = data.articles.map(parseNewsArticle);
    return {
      query,
      length: articles.length,
      articles,
    };
  } catch (error) {
    return error;
  }
}

function parseNewsArticle(a: any) {
  return {
    author: a.author,
    title: a.title,
    publishedAt: a.published_date,
    summary: a.summary,
    excerpt: a.excerpt,
    link: a.link,
    country: a.country,
    language: a.language,
  };
}
