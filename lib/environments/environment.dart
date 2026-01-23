enum Environment { mock, dev, prod }

extension EnvironmentX on Environment {
  bool get isMock => this == Environment.mock;

  bool get isDev => this == Environment.dev;

  bool get isProduction => this == Environment.prod;
}
