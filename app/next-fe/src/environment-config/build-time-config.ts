type BuildTimeConfig = {
  appName: string;
};

const buildTimeConfig: BuildTimeConfig = {
  appName: process.env.NEXT_PUBLIC_APP_NAME!,
};

export { buildTimeConfig };
