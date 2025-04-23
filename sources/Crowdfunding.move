module  0x28f7aca13358cee8f8e686c3bca7dcde17a74e3bee7b0ab73281c372b2d28ec9::ScholarshipDistribution 
   {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct to represent a scholarship fund
    struct ScholarshipFund has store, key {
        total_amount: u64,
    }

    /// Function to register a scholarship fund by an institute
    public fun register_scholarship(institute: &signer, amount: u64) {
        let deposit = coin::withdraw<AptosCoin>(institute, amount);
        coin::deposit<AptosCoin>(signer::address_of(institute), deposit);

        let fund = ScholarshipFund {
            total_amount: amount,
        };
        move_to(institute, fund);
    }

    /// Function to disburse funds to a student
    public fun disburse_scholarship(institute: &signer, student: address, amount: u64) acquires ScholarshipFund {
        let fund = borrow_global_mut<ScholarshipFund>(signer::address_of(institute));
        assert!(fund.total_amount >= amount, 1); // Ensure enough funds

        let payout = coin::withdraw<AptosCoin>(institute, amount);
        coin::deposit<AptosCoin>(student, payout);

        fund.total_amount = fund.total_amount - amount;
    }
}