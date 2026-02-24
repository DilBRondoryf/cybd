create or replace procedure Re_Create ()
language plpgsql
as $$
	begin
    drop table if exists ContractOption;
		drop table if exists InventorySpecification;
		drop table if exists AdditionalOption;
		drop table if exists Inventory;
		drop table if exists InventoryRental;
		drop table if exists Employee;
		drop table if exists Contract;
		drop table if exists GameMap;
		drop table if exists GameType;
		drop table if exists Addendum;
		drop table if exists Clients;
		call create_1();
	end;
$$;
