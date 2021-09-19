pragma ton-solidity >= 0.43.0;

pragma AbiHeader expire;
pragma AbiHeader time;

import '../true-nft/components/true-nft-core/src/Index.sol';

contract IndexResolver {
    TvmCell _codeIndex;

    function resolveCodeHashIndex(
        address addrRoot,
        address addrOwner
    ) public view returns (uint256 codeHashIndex) {
        return tvm.hash(_buildIndexCode(addrRoot, addrOwner));
    }

    function resolveIndex(
        address addrRoot,
        address addrData,
        address addrOwner
    ) public view returns (address addrIndex) {
        TvmCell code = _buildIndexCode(addrRoot, addrOwner);
        TvmCell state = _buildIndexState(code, addrData);
        uint256 hashState = tvm.hash(state);
        addrIndex = address.makeAddrStd(0, hashState);
    }

    function _buildIndexCode(
        address addrRoot,
        address addrOwner
    ) internal virtual view returns (TvmCell) {
        TvmBuilder salt;
        salt.store(addrRoot);
        salt.store(addrOwner);
        return tvm.setCodeSalt(_codeIndex, salt.toCell());
    }

    function _buildIndexState(
        TvmCell code,
        address addrData
    ) internal virtual pure returns (TvmCell) {
        return tvm.buildStateInit({
            contr: Index,
            varInit: {_addrData: addrData},
            code: code
        });
    }


}
