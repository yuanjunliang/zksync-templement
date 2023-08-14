import log4js from "log4js";
log4js.configure({
  appenders: {
    file: { type: "file", filename: "logs/logs.log" },
    out: { type: "stdout" },
  },
  categories: { default: { appenders: ["file", "out"], level: "error" } },
});
const logger = log4js.getLogger("logger");
logger.level = "debug";

export default logger;
