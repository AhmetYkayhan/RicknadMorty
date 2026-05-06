import SwiftUI
import Testing
@testable import DesignSystem

@Suite("DesignSystem tokens")
struct TokensTests {
    @Test("spacing tokens are positive")
    func spacings() {
        #expect(AppSpacing.xxs > 0)
        #expect(AppSpacing.xs > 0)
        #expect(AppSpacing.sm > 0)
        #expect(AppSpacing.md > 0)
        #expect(AppSpacing.lg > 0)
        #expect(AppSpacing.xl > 0)
        #expect(AppSpacing.xxl > 0)
    }

    @Test("spacing tokens are ordered")
    func spacingOrder() {
        #expect(AppSpacing.xxs < AppSpacing.xs)
        #expect(AppSpacing.xs < AppSpacing.sm)
        #expect(AppSpacing.sm < AppSpacing.md)
        #expect(AppSpacing.md < AppSpacing.lg)
        #expect(AppSpacing.lg < AppSpacing.xl)
        #expect(AppSpacing.xl < AppSpacing.xxl)
    }
}
