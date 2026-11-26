#include <cstdint>

#include "gtest/gtest.h"
#include "Vdut.h"

class TestImmExtend : public ::testing::Test
{
    Vdut dut;

    void SetUp() override
    {
        dut.imm_src = 0;
        dut.imm_input = 0;
    }

    void TearDown() override
    {
        dut.final();
    }

protected:
    std::uint32_t extend(std::uint8_t format, std::uint32_t instruction)
    {
        dut.imm_src = format;
        dut.imm_input = instruction >> 7;  // Pass instruction bits [31:7].
        dut.eval();
        return dut.imm_ext;
    }
};

TEST_F(TestImmExtend, ITypeTest)
{
    EXPECT_EQ(extend(0, 0x00830293u), 0x00000008u);  // ADDI +8
    EXPECT_EQ(extend(0, 0xff830293u), 0xfffffff8u);  // ADDI -8
}

TEST_F(TestImmExtend, STypeTest)
{
    EXPECT_EQ(extend(1, 0xfe530623u), 0xffffffecu);  // SB offset -20
}

TEST_F(TestImmExtend, BTypeTest)
{
    EXPECT_EQ(extend(2, 0xfee312e3u), 0xffffffe4u);  // BNE offset -28
    EXPECT_EQ(extend(2, 0x000010e3u), 0x00000800u);  // BNE offset +2048
}

TEST_F(TestImmExtend, UTypeTest)
{
    EXPECT_EQ(extend(3, 0x123452b7u), 0x12345000u);  // LUI 0x12345
}

TEST_F(TestImmExtend, JTypeTest)
{
    EXPECT_EQ(extend(4, 0x001000efu), 0x00000800u);  // JAL offset +2048
    EXPECT_EQ(extend(4, 0xffdff06fu), 0xfffffffcu);  // JAL offset -4
}

TEST_F(TestImmExtend, DefaultTest)
{
    EXPECT_EQ(extend(7, 0xff830293u), 0xfffffff8u);  // I-type fallback
}

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}