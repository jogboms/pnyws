enum Environment { MOCK, DEVELOPMENT, PRODUCTION }

extension EnvironmentX on Environment {
  bool get isMock => this == Environment.MOCK;

  bool get isDev => this == Environment.DEVELOPMENT;

  bool get isProduction => this == Environment.PRODUCTION;
}
