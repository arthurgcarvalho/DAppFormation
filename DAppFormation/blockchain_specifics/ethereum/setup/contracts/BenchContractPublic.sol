pragma solidity 0.4.26;


contract BenchContractPublic {


    mapping(string => string) map;
    mapping(uint => uint) map2;

    uint tmp = 42;

    // new mappings
    mapping(address => uint[]) private patient_provider_map;   // info about consent previously granted

    function getTmp() public view returns(uint) {
        return tmp;
    }

    function setTmp(uint value) public {
        tmp = value;
    }

    function writeData(string memory _key, string memory _value) public {
        map[_key] = _value;
        bool    found_provider = false;
        uint256 array_length   = patient_provider_map[msg.sender].length;

        uint  _provider = block.timestamp % 100; //100 providers
        bool _consent = (block.timestamp % 2 == 0) ? true : false;

        //for all providers who have the consent to access the patient's data
        for (uint256 index = 0; index < array_length; index++) {

            // if the provider matches what came from the UI
            if(patient_provider_map[msg.sender][index] == _provider)   {

                if(_consent == false) { //revoke consent                    
                    patient_provider_map[msg.sender][index] = patient_provider_map[msg.sender][array_length -1];
                    delete patient_provider_map[msg.sender][array_length -1];
                    patient_provider_map[msg.sender].length--;
                }
                found_provider = true;
                break;
            }
        }

        // adding a new provider to the list
        if(found_provider == false && _consent == true) {              
            patient_provider_map[msg.sender].push(_provider);
        }
    }

    function readData(string memory _key) public view returns(string memory) {
        return map[_key];
    }

    function writeMuchData(uint len, uint start, uint delta) public {
        for (uint i = start; i < start+len; i++) {
            map2[i] = delta + i;
        }
    }

    function readMuchData(uint _len, uint _start) public view returns(uint) {
        uint sum = 0;
        for (uint i=_start; i<_start+_len; i++) {
            sum = sum + map2[i];
        }
        return sum;
    }

    function queryDoNothing() public pure returns(uint) {
        return 1;
    }

    function invokeDoNothing() public pure returns(uint) {
        return 1;
    }

    function matMultHelper(uint[][] memory mat1, uint[][] memory mat2) private pure returns(uint) {
        uint r1 = mat1.length; // rows of mat1
        uint c1 = mat1[0].length; // columns of mat1
        uint c2 = mat2[0].length; // columns of mat1
        uint sum;
        uint matrixSum;

        uint[][] memory result = new uint[][](c1);

        for (uint i=0; i < c1; i++) {
            uint[] memory temp = new uint[](c1);
            for(uint j = 0; j < c1; j++){
                temp[j]=i+j;
            }
            result[i] = temp;
        }

        for(i = 0; i < r1; ++i) {
            for(j = 0; j < c2; ++j) {
                sum = 0;
                for(uint k = 0; k < c1; ++k) {
                sum += mat1[i][k] * mat2[k][j];
                }
                result[i][j] = sum;
            }
        }

        for(i = 0; i < result.length; ++i) {
            for (j = 0; j < result[i].length; ++j){
                matrixSum += result[i][j];
            }
        }
        return(matrixSum);
    }

     function matMult(uint n) public pure returns(uint){
        uint f = 1;
        uint[][] memory mat1 = new uint[][](n);

        for (uint i=0; i < n; i++) {
            uint[] memory temp = new uint[](n);
            for(uint j = 0; j < n; j++){
                temp[j]=i+j;
            }
            mat1[i] = temp;
        }

        uint[][] memory mat2 = mat1;

        for (i=0; i<n; i++){
            for (j=0; j<n; j++){
            mat1[i][j] = f;
            f = f+1;
            }
        }
        mat2 = mat1;
        return matMultHelper(mat1, mat2);
    }

    function queryMatrixMultiplication(uint n) public pure returns(uint) {
        return matMult(n);
    }

    function invokeMatrixMultiplication(uint n) public pure returns(uint) {
        return matMult(n);
    }

    function setMatrixMultiplication (uint n) public returns(uint) {
         tmp = matMult(n);
         return tmp;
    }
}